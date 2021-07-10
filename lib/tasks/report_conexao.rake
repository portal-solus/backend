# frozen_string_literal: true

desc 'Reads Conexão forms in the system'
task report_conexao: :environment do
  puts Conexao.all
end
