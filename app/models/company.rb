# frozen_string_literal: true

class Company
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :name, type: String
  field :year, type: String
  field :services, type: String
  field :url, type: String
  field :logo, type: String

  field :incubated, type: Boolean
  field :allowed, type: Boolean
  field :active, type: Boolean

  field :emails, type: Array
  field :ecosystems, type: Array
  field :technologies, type: Array
  field :phones, type: Array
  field :companySize, type: Array

  field :description, type: Hash
  field :classification, type: Hash
  field :address, type: Hash

  validates :name, :year, :emails, :description, :incubated, :ecosystems, :services, :address,
            :classification,
            presence: true
  validates :name, length: { in: 2..100 }, uniqueness: { message: "#{name} already taken" }
  validates :url, :logo, url: true
  validates :phones, phones: true

  validate :valid_year?, :valid_company_size?, :valid_classification?, :valid_address?

  def valid_address?
    is_valid = !address.nil? &&
               address.is_a?(Hash) &&
               address.key?(:city)

    errors.add(:address, 'address requires at least the city') unless is_valid
  end

  def valid_year?
    return if year.nil? || year == 'N/D'

    is_valid = year.is_a?(String) &&
               year.match?(/^\d{4}$/) &&
               year.to_i <= Time.zone.now.year
    errors.add(:year, 'must be a string representing a non-future year') unless is_valid
  end

  def valid_company_size?
    is_valid = !companySize.nil? &&
               companySize.is_a?(Array) &&
               companySize.all? { |size| company_sizes.include?(size) }
    errors.add(:companySize, "must be one of #{company_sizes}") unless is_valid
  end

  def valid_classification?
    return if classification.nil?

    c = classification

    is_valid = c.is_a?(Hash) &&
               c.key?(:major) &&
               c.key?(:minor) &&
               cnae_majors.include?(c[:major]) &&
               cnae_major_to_minors[c[:major]].include?(c[:minor])

    errors.add(:classification, 'invalid major and/or minor') unless is_valid
  end

  def self.create_from(row)
    classification = classify(row)

    new_company = Company.new(
      {
        name: row[2],
        year: row[4],
        emails: row[7].split(';'),
        description: { long: row[13] },
        incubated: incubated?(row),
        ecosystems: row[19].split(';'),
        services: row[14],
        address: define_address(row),
        phones: format_phone(row[6]),
        url: format_url(row[17]),
        technologies: row[15].split(';'),
        logo: create_image_url(row[16]),
        classification: classification,
        companySize: size(row, classification)
      }
    )

    raise StandardError, new_company.errors.full_messages unless new_company.save

    new_company
  end

  def self.size(row, classification)
    sizes = row[20] == 'Unicórnio' ? [row[20]] : []

    employees = row[21].to_i

    return sizes.append('Não Informado') unless employees.positive?

    if classification[:major] == 'Indústria de Transformação'
      case employees
      when 1...20
        sizes.append 'Microempresa'
      when 20...100
        sizes.append 'Pequena Empresa'
      when 100...500
        sizes.append 'Média Empresa'
      else
        sizes.append 'Grande Empresa'
      end
    else
      case employees
      when 1...10
        sizes.append 'Microempresa'
      when 0...50
        sizes.append 'Pequena Empresa'
      when 50...100
        sizes.append 'Média Empresa'
      else sizes.append 'Grande Empresa'
      end
    end

    sizes
  end

  def self.format_phone(raw)
    raw.split(';').map do |phone|
      numbers = phone.gsub(/\D/, '')
      case numbers.size
      when 13
        # +55 (11) 98765 - 4321
        "+#{numbers[0..1]} (#{numbers[2..3]}) #{numbers[4..8]} - #{numbers[9..]}"
      when 12
        # +55 (11) 8765 - 4321
        "+#{numbers[0..1]} (#{numbers[2..3]}) #{numbers[4..7]} - #{numbers[8..]}"
      when 11
        # (11) 98765 - 4321
        "(#{numbers[0..1]}) #{numbers[2..6]} - #{numbers[7..]}"
      when 10
        # (11) 8765 - 4321
        "(#{numbers[0..1]}) #{numbers[2..5]} - #{numbers[6..]}"
      when 9
        # 98765 - 4321
        "#{numbers[0..4]} - #{numbers[5..]}"
      when 8
        # 8765 - 4321
        "#{numbers[0..3]} - #{numbers[4..]}"
      else
        # no particular format
        numbers
      end
    end
  end

  def self.create_image_url(raw)
    "https://drive.google.com/uc?export=view&id=#{raw}"
  end

  def self.format_url(raw)
    return nil if raw.size.zero?

    return "https://#{raw}" if raw[0..3] != 'http'

    raw
  end

  def self.incubated?(row)
    yesses = ['Sim. A empresa está incubada.', 'Sim. A empresa já está graduada']
    yesses.include? row[18]
  end

  def self.define_address(row)
    {
      venue: row[8],
      neightborhood: row[9],
      city: row[10].split(';'),
      state: row[11],
      cep: row[12]
    }
  end

  def self.classify(row)
    default = { major: '', minor: '' }

    return default if row.nil? || row[5].size.zero?

    code = row[5][0..1]
    major_minor = cnae_code_to_major_minor[code]

    return default unless code && major_minor

    {
      major: major_minor[:major],
      minor: major_minor[:minor]
    }
  end
end
