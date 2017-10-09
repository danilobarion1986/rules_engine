require_relative '../core/rule'

RSpec.describe RulesEngine::Core::Rule do
  let(:rule) { RulesEngine::Core::Rule.new(titulo, descricao, assertion, Fixnum) }
  let(:titulo) { 'titulo' }
  let(:descricao) { 'descricao da regra' }
  let(:assertion) { -> (x) { x + 1 } }

  describe '#apply_to' do
    let(:result) { rule.apply_to(1) }

    it 'return itself' do
      expect(result.object_id).to eq(rule.object_id)
    end

    it 'mark the rule as applied' do
      expect(result.applied?).to be true
    end

    it 'produce the correct result' do
      expect(result.result).to eq(2)
    end

    context 'when applied twice' do
      it 'reset the result after first application' do
        expect(rule.apply_to(1).result).to eq(2)
        expect(rule.apply_to(1).result).to eq(2)
      end

      context 'when the rule is not reapplicable' do
        it 'raise StandardError' do
          rule.reapplicable = false

          expect(rule.apply_to(1).result).to eq(2)
          expect { rule.apply_to(1) }.to raise_error(StandardError)
        end
      end
    end

    context 'when receive object of unexpected class' do
      let(:result) { rule.apply_to('wrong class') }

      it 'return itself' do
        expect(result.object_id).to eq(rule.object_id)
      end

      it 'have error added to errors property' do
        expect(result.errors).to_not be_empty
      end
    end
  end
end
