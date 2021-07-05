module Mint
  class Compiler
    def _compile(node : Ast::Route) : Codegen::Node
      expression =
        compile node.expression

      arguments =
        compile node.arguments

      mapping =
        node
          .arguments
          .map { |argument| "'#{argument.name.value}'" }

      decoders =
        node
          .arguments
          .map { |argument| @serializer.decoder(cache[argument]) }

      js.object({
        "handler"  => js.arrow_function(arguments, expression),
        "decoders" => js.array(decoders),
        "mapping"  => js.array(mapping),
        "path"     => "`#{node.url}`",
      })
    end
  end
end
