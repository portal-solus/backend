# frozen_string_literal: true

require 'rest-client'
require 'json'

class GetCompaniesService
  def self.run
    request && parse && cleanup
  end

  def self.request
    sheets_api_key = Rails.application.credentials.google_sheets_API_key
    sheet_id = '14uwSMZee-CoIJyIpcEf4t17z6eYN-ElYgw_O7dtU5Ok'
    sheet_name = 'EMPRESAS'
    url = "#{base_url}/#{sheet_id}/values/'#{sheet_name}'?key=#{sheets_api_key}"
    response = RestClient.get url
    @@data = JSON.parse(response.body)['values']
  rescue RestClient::ExceptionWithResponse => e
    services_logger.debug "[GetCompaniesService::request] #{e}"
    @@data = nil
  end

  def self.parse
    raw_companies = @@data.slice(1, @@data.size - 1)
    raw_companies.each_with_index do |row, index|
      Company.create_from(row)
    rescue StandardError => e
      services_logger.debug "[GetCompaniesService::parse - Linha: #{index + 2}] #{e}"
    end
  end

  def self.cleanup
    Company.where({ created_at: { '$lt': 1.hour.ago } }).delete_all
  end

  def self.base_url
    'https://sheets.googleapis.com/v4/spreadsheets'
  end
end
