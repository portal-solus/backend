# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Conexoes', type: :request do
  let(:valid_attr) do
    {
      personal: {
        name: 'Neymar',
        email: 'ney10@hotmail.com',
        represent: 'Empresa'
      },
      org: {
        name: 'Desempedidos',
        email: 'dsp@gmail.com',
        cnpj: '14.952.400/0002-31',
        sensitiveData: 'Não',
        size: 'Média',
        phone: '11 961442245',
        address: 'rua do Matão, 1010',
        city: 'São Paulo'
      },
      demand: {
        cnae: {
          major: 'Indústria de Transformação',
          minor: 'Bebidas'
        },
        description: 'Quero elaborar um novo produto para jogadores de futebol',
        expectation: 'Novo produto',
        wantedProfile: 'Saúde',
        necessity: 'Desenvolvimento de P&D em parceria'
      }
    }
  end

  describe 'POST /conexao' do
    it 'blocks requests that fail validation' do
      allow(Conexao).to receive(:create!).and_raise { raise ActiveRecord::RecordInvalid }
      post '/conexao'
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns the just-created object' do
      created_obj = valid_attr.merge({ id: 'hand-made-id' })
      allow(Conexao).to receive(:create!).and_return(created_obj)
      post '/conexao',
           params: { conexao: { personal: valid_attr[:personal], org: valid_attr[:org],
                                demand: valid_attr[:demand] } }
      expect(response.body).to eql({ conexao_form: created_obj }.to_json)
    end
  end
end
