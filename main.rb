require_relative 'rule'
require_relative 'rule_set'
require_relative 'user'
require 'pry-byebug'

# Objeto que será avaliado pela regra
danilo = User.new('Danilo', 30, :masculino)

# Regra 1
rule_title = "My first rule!"
rule_description = "This rule aims to test my new rules engine!"
rule_assertion = -> (x) { x > 18 }
rule_subject = danilo.age
maior_de_idade = RulesEngine::Core::Rule.new(rule_title, rule_description, rule_assertion, rule_subject)

# Regra 2
rule_title_2 = "My second rule!"
rule_description_2 = "This rule aims to test my new rules engine!"
rule_assertion_2 = -> (x) { x == :masculino }
rule_subject_2 = danilo.gender
masculino = RulesEngine::Core::Rule.new(rule_title_2, rule_description_2, rule_assertion_2, rule_subject_2)

puts "\nAplicação de regras isoladamente"
maior = maior_de_idade.apply
masc = masculino.apply
puts "Masculino meta: #{masc.metadata}"
puts "Maior de idade meta: #{maior.metadata}"
puts "Masculino? #{masc.result}"
puts "Maior de idade? #{maior.result}"

puts "\nAplicação de conjunto de regras"
rule_set_title = "My first rule set!"
rule_set_description = "This rule set aims to test my new rules engine!"
regras_de_venda = RulesEngine::Core::RuleSet.new(rule_set_title, rule_set_description)

regra_inexistente = RulesEngine::Core::Rule.new(nil, nil, nil, nil)
regras_de_venda.add_rule(maior_de_idade)
regras_de_venda.add_rule(masculino)
puts regras_de_venda.rules.size
regras_de_venda.del_rule(regra_inexistente)
regras_de_venda.del_rule(maior_de_idade)
puts regras_de_venda.rules.size

regras_aplicadas = regras_de_venda.apply_all
puts regras_aplicadas.class
puts regras_aplicadas.results
