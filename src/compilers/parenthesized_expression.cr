module Mint
  class Compiler
    def _compile(node : Ast::ParenthesizedExpression) : Codegen::Node
      expression =
        compile node.expression

      Codegen.join ["(", expression, ")"]
    end
  end
end
