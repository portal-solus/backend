# frozen_string_literal: true

class ConexoesController < ApplicationController
  def create
    @conexao = Conexao.create!(create_params)
    render json: { conexao_form: @conexao }
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  private

  def create_params
    params.require(:conexao).permit(personal: {}, org: {}, demand: {})
  end
end
