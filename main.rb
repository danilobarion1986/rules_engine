require_relative 'rule'
require_relative 'rule_set'
require_relative 'user'
require 'pry-byebug'

# Objeto que será avaliado pela regra
danilo = User.new('Danilo', 30, :masculino, false)
pedro = User.new('Pedro', 2, :masculino, true)

# Regra 1
maior_de_idade = RulesEngine::Core::Rule.new(:maior_18, 'O usuário deve ser maior de 18 anos.',
                                             ->(x) { x.age > 18 }, User)

# Regra 2
masculino = RulesEngine::Core::Rule.new(:masculino, 'O usuário deve ser do sexo masculino.',
                                        ->(x) { x.gender == :masculino }, User)

# Regra 3
usuario_premium = RulesEngine::Core::Rule.new(
  :usuario_premium, 
  'O usuário deve ser premium.', 
  ->(x) { x.premium }, User)

# puts "\nAplicação de regras isoladamente"
# maior = maior_de_idade.apply_to(danilo)
# masc = masculino.apply_to(danilo)
# puts "Masculino? #{masc.result}"
# puts "Maior de idade? #{maior.result}"

regras = RulesEngine::Core::RuleSet.new('Regras de Desconto', 
  'Este conjunto de regras define quem terá direito ao desconto especial na linha de produtos masculinos.')

puts "\nAplicação de conjunto de regras"

puts "\nAdicionar e logo aplicar"
regras.add(maior_de_idade).and_apply_to(danilo)
puts regras.results
regras.reset

puts "\nAdicionar uma por vez e aplicar todas"
regras.add(maior_de_idade).add(masculino).add(usuario_premium).and_apply_all_to(danilo)
puts regras.results
regras.reset

puts "\nAdicionar diversas de uma vez e aplicar todas"
regras.add_many([maior_de_idade, masculino, usuario_premium]).and_apply_all_to(danilo)
puts regras.results
regras.reset

puts "\nAdicionar diversas de uma vez e aplicar todas (2 etapas)"
regras.add_many([maior_de_idade, masculino, usuario_premium])
regras.and_apply_all_to(danilo)
puts regras.results
regras.reset

puts "\nAplicar uma regra específica a um objeto"
regras.add_many([maior_de_idade, masculino, usuario_premium])
      .apply(usuario_premium)
      .to(danilo)
puts regras.results
regras.reset