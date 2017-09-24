require_relative 'rule'
require_relative 'rule_set'
require_relative 'user'
require 'pry-byebug'

# Objeto que será avaliado pela regra
danilo = User.new('Danilo', 30, :masculino)

# Regra 1
maior_de_idade = RulesEngine::Core::Rule.new(:maior_18, 'O usuário deve ser maior de 18 anos.',
                                             ->(x) { x.age > 18 }, User)

# Regra 2
masculino = RulesEngine::Core::Rule.new(:masculino, 'O usuário deve ser do sexo masculino',
                                        ->(x) { x.gender == :masculino }, User)

# puts "\nAplicação de regras isoladamente"
# maior = maior_de_idade.apply_to(danilo)
# masc = masculino.apply_to(danilo)
# puts "Masculino? #{masc.result}"
# puts "Maior de idade? #{maior.result}"

puts "\nAplicação de conjunto de regras"
regras_de_venda = RulesEngine::Core::RuleSet.new('Regras de Desconto', 'Este conjunto de regras define quem terá direito ao desconto especial na linha de produtos masculinos.')

regras_de_venda.add_rule(maior_de_idade)
regras_de_venda.add_rule(masculino)
# regras_aplicadas = regras_de_venda.apply_all_to(danilo)
# puts regras_aplicadas.results

regras_de_venda.apply_rule(masculino).to(danilo)
regras_de_venda.apply_rule(maior_de_idade).to(danilo)
puts regras_de_venda.results
