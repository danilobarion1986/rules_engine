require 'pry-byebug'
require_relative 'core/rule'
require_relative 'core/rule_set'
require_relative 'generators/documents'
require_relative 'pipelines/branch'
require_relative 'pipelines/step'
require_relative 'pipelines/flow'
require_relative 'user'

class Main
  include RulesEngine::Core
  include RulesEngine::Generators
  include RulesEngine::Pipelines

  def initialize
    # Objeto que será avaliado pela regra
    @danilo = User.new('Danilo', 30, :masculino, false)
    @pedro = User.new('Pedro', 2, :masculino, true)
  end

  def criar_regras
    puts "\nCriação de regras"
    # Regra 1
    @maior_de_idade = Rule.new('Maior de 18 anos', 'O usuário deve ser maior de 18 anos.',
      -> (x) { x.age > 18 }, User)
    # Regra 2
    @masculino = Rule.new('Masculino', 'O usuário deve ser do sexo masculino.',
      lambda do |x|
        x.gender == :masculino
      end, User)
    # Regra 3
    @usuario_premium = Rule.new(
      'Usuário Premium',
      'O usuário deve ser premium.',
      ->(x) { x.premium }, User)
  end

  def aplicar_regras
    puts "\nAplicação de conjunto de regras"
    @regras = RuleSet.new('Regras de Desconto',
        'Este conjunto de regras define quem terá direito ao desconto especial na linha de produtos masculinos.')

    puts "\nAdicionar e logo aplicar"
    @regras.add(@maior_de_idade).and_apply_to(@danilo)
    puts @regras.results
    @regras.reset

    puts "\nAdicionar uma por vez e aplicar todas"
    @regras.add(@maior_de_idade).add(@masculino).add(@usuario_premium).and_apply_all_to(@danilo)
    puts @regras.results
    @regras.reset

    puts "\nAdicionar diversas de uma vez e aplicar todas"
    @regras.add_many([@maior_de_idade, @masculino, @usuario_premium]).and_apply_all_to(@danilo)
    puts @regras.results
    @regras.reset

    puts "\nAdicionar diversas de uma vez e aplicar todas (2 etapas)"
    @regras.add_many([@maior_de_idade, @masculino, @usuario_premium])
    @regras.and_apply_all_to(@danilo)
    puts @regras.results
    @regras.reset

    puts "\nAplicar uma regra específica a um objeto"
    @regras.add_many([@maior_de_idade, @masculino, @usuario_premium])
           .apply(@usuario_premium)
           .to(@danilo)
    puts @regras.results
    @regras.reset
  end

  def criar_docs
    puts "\nCriação de documentação a partir de um RuleSet"
    @regras.add_many([@maior_de_idade, @masculino, @usuario_premium])
    Documents.new(@regras).create_docs # ('./business_rules')
  end

  def criar_flow
    puts "\nCriação de branch, step e flow"
    branch_true1 = Branch.new(true, "call true action")
    branch_false1 = Branch.new(false, "call false action")
    step1 = Step.new.add_branchs( [branch_true1, branch_false1] )

    branch_true2 = Branch.new(true, "call true action again")
    branch_false2 = Branch.new(false, "call false action again")
    step2 = Step.new.add_branchs( [branch_true2, branch_false2] )

    flow = Flow.new.add_steps( [step1, step2] )
    puts flow.representation
  end
end

m = Main.new
m.criar_regras
m.aplicar_regras
m.criar_docs
m.criar_flow










