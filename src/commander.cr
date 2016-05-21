require "./commander/*"

module Commander
  alias Types = String | Int32 | Int64 | Float32 | Float64 | Bool | Nil
  alias Params = Array(String)
  alias Arguments = Array(String)
  alias Runner = Proc(Options, Arguments, Void)
  alias OptionalRunner = Proc(Options, Arguments, Nil)
  alias NoReturnRunner = Proc(Options, Arguments, NoReturn)
  alias ArrayStringRunner = Proc(Options, Arguments, Array(String))

  def self.run(command : Command, params : Params)
    command.invoke(params)
    exit 0
  rescue ex : Commander::Exception
    STDERR.puts ex.message
    exit 2
  end
end
