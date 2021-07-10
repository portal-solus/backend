# frozen_string_literal: true

$areas = [
  {
    name: 'Ciências Agrárias',
    subareas: [
      'Agronomia',
      'Recursos Florestais e Engenharia Florestal',
      'Engenharia Agrícola',
      'Zootecnia',
      'Medicina Veterinária',
      'Recursos Pesqueiros e Engenharia de Pesca',
      'Ciência e Tecnologia de Alimentos'
    ]
  },
  {
    name: 'Ciências Biológicas',
    subareas: [
      'Biologia Geral',
      'Genética',
      'Botânica',
      'Zoologia',
      'Ecologia',
      'Morfologia',
      'Fisiologia',
      'Bioquímica',
      'Biofísica',
      'Farmacologia',
      'Imunologia',
      'Microbiologia',
      'Parasitologia'
    ]
  },
  {
    name: 'Ciências da Saúde',
    subareas: [
      'Medicina',
      'Odontologia',
      'Farmácia',
      'Enfermagem',
      'Nutrição',
      'Saúde Coletiva',
      'Fonoaudiologia',
      'Fisioterapia e Terapia Ocupacional',
      'Educação Física'
    ]
  },
  {
    name: 'Ciências Exatas e da Terra',
    subareas: [
      'Matemática',
      'Probabilidade e Estatística',
      'Ciência da Computação',
      'Astronomia',
      'Física',
      'Química',
      'GeoCiências',
      'Oceanografia'
    ]
  },
  {
    name: 'Engenharias',
    subareas: [
      'Engenharia Civil',
      'Engenharia de Minas',
      'Engenharia de Materiais e Metalúrgica',
      'Engenharia Elétrica',
      'Engenharia Mecânica',
      'Engenharia Química',
      'Engenharia Sanitária',
      'Engenharia de Produção',
      'Engenharia Nuclear',
      'Engenharia de Transportes',
      'Engenharia Naval e Oceânica',
      'Engenharia Aeroespacial',
      'Engenharia Biomédica'
    ]
  },
  {
    name: 'Ciências Humanas',
    subareas: [
      'Filosofia',
      'Sociologia',
      'Antropologia',
      'Arqueologia',
      'História',
      'Geografia',
      'Psicologia',
      'Educação',
      'Ciência Política',
      'Teologia'
    ]
  },
  {
    name: 'Ciências Sociais Aplicadas',
    subareas: [
      'Direito',
      'Administração',
      'Economia',
      'Arquitetura e Urbanismo',
      'Planejamento Urbano e Regional',
      'Demografia',
      'Ciência da Informação',
      'Museologia',
      'Comunicação',
      'Serviço Social',
      'Economia Doméstica',
      'Desenho Industrial',
      'Turismo'
    ]
  },
  {
    name: 'Linguística, Letras e Artes',
    subareas: %w[Linguística Letras Artes]
  }
]

$CompressArea = $areas.map do |area|
  area[:name].sub(/Ciências (da )?/, '')
end

def knowdge_fields
  $CompressArea
end

def knowledge_areas
  $areas
end
