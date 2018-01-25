# Migrate

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `migrate` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:migrate, "~> 0.1.0"}]
    end
    ```

  2. Ensure `migrate` is started before your application:

    ```elixir
    def application do
      [applications: [:migrate]]
    end
    ```

# Usage:
## compile using 
```
./compile
```

## Run
```
./migrate --input-path="input.json"
```
