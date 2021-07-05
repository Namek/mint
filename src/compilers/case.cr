module Mint
  class Compiler
    def compile(node : Ast::Case, block : Proc(Codegen::Node, Codegen::Node)? = nil) : Codegen::Node
      if checked.includes?(node)
        _compile node, block
      else
        ""
      end
    end

    def _compile(node : Ast::Case, block : Proc(Codegen::Node, Codegen::Node)? = nil) : Codegen::Node
      condition =
        compile node.condition

      variable, condition_let =
        js.let condition

      body =
        node
          .branches
          .sort_by(&.match.nil?.to_s)
          .map_with_index do |branch, index|
            _compile branch, index, variable, block
          end

      js.iif do
        js.statements([condition_let, js.ifchain(body)])
      end
    end
  end
end
