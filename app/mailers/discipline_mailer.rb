class DisciplineMailer < ApplicationMailer
  default from: 'joao.daniel@usp.br',
          to: 'joao.daniel@usp.br'

  def warnings
    @warnings = params[:warnings]
    @sheet_url = 'https://google.com'
  end
end
