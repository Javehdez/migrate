defmodule Migrate do
  @commands_key_display "display"
  @commands_key_commands "commands"
  @commands_key_access 	"access"
  @commands_key_args "args"
  @commands_key_buttonDisplay "buttonDisplay"
  @commands_key_command "command"
  @commands_key_display "display"

  def main(args) do
    IO.puts("Args: #{inspect args}")
    {options , argsv , invalid } =
    OptionParser.parse(
      args,
      switches: [
        input_path: :string
        ])
    IO.puts("Options: #{inspect options}")
    IO.puts("Options: #{inspect argsv}")
    IO.puts("Invalid Options: #{inspect invalid}")

    input_path = options[:input_path]

    case import_commands_file(input_path) do
      nil ->  IO.puts("Aborting: input is empty or does not exist")
      input ->
        output = convert(input)
        export_commands_file(output)
    end
  end

  def convert(input) do
    top_parents = Map.keys(input)
    Enum.reduce(top_parents, %{}, fn parent, state ->
      commands = Map.get(input, parent, [])
      Enum.reduce(commands, state, fn command, state ->
        case Map.get(command, @commands_key_display) do
          nil -> state
          display ->
            commands = Map.get(command, @commands_key_commands, [])
            commands = Enum.map(commands, &validate_command_args&1)
            stored_key = Map.get(state, display)
            key = validate_command_key(stored_key, display, parent)
            access = %{parent => true}
            payload = %{@commands_key_access => access, @commands_key_commands => commands}
            Map.put(state, key, payload)
        end
      end)
    end)
  end

  defp validate_command_key(stored_key, key, parent_key) do
    cond do
      is_nil(stored_key) -> key
      true ->
        parent_key = String.capitalize(parent_key)
        new_key = "#{key} - #{parent_key}"
        IO.puts("[Key Validation FAILED] - Duplicate found: #{key} using: #{new_key}")
        new_key
    end
  end

  defp validate_command_args(command) do
    args = Map.get(command, @commands_key_args, [])
    Map.put(command, @commands_key_args, args)
  end

  defp import_commands_file(filePath) do
    case File.read(filePath) do
      {:ok, raw} ->
      case Poison.Parser.parse(raw) do
        {:ok, parsed} -> parsed
        _ -> nil
      end
      _ -> nil
    end
  end

  def export_commands_file(output) do
    save_path = "exported.json"
    File.write(save_path, Poison.encode!(output, strict_keys: true, pretty: true))
    IO.puts("Exported at #{save_path}.")
  end
end
