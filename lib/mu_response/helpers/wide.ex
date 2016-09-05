defmodule MuResponse.Helpers.Wide do
  @doc """
  Widifies the input `input`, shifting all ASCII-legit characters to their wide representation.

  Returns widified input.

  ## Examples

      iex> "hello, мир!" |> MuResponse.Helpers.Wide.wide!
      "ｈｅｌｌｏ， мир！"

      iex> "abcdeXYZ,.-!()[]" |> MuResponse.Helpers.Wide.wide!
      "ａｂｃｄｅＸＹＺ，．－！（）［］"

      iex> "abcdeXYZ,.-!()[]" |> MuResponse.Helpers.Wide.wide! |> MuResponse.Helpers.Wide.wide!
      "ａｂｃｄｅＸＹＺ，．－！（）［］"

  """
  def wide!(input) do
   input
   |> to_char_list
   |> Enum.map(&widify_char/1)
   |> to_string
  end

  @doc """
  Un-widifies the input `input`, shifting all wide represented characters to their ASCII values.

  Returns un-widified input.

  ## Examples

      iex> "ｈｅｌｌｏ， мир！" |> MuResponse.Helpers.Wide.unwide!
      "hello, мир!"

      iex> "ａｂｃｄｅＸＹＺ，．－！（）［］" |> MuResponse.Helpers.Wide.unwide!
      "abcdeXYZ,.-!()[]"

      iex> "ａｂｃｄｅＸＹＺ，．－！（）［］" |> MuResponse.Helpers.Wide.unwide! |> MuResponse.Helpers.Wide.wide!
      "ａｂｃｄｅＸＹＺ，．－！（）［］"

  """
  def unwide!(input) do
   input
   |> to_char_list
   |> Enum.map(&unwidify_char/1)
   |> to_string
  end

  ##############################################################################
  ###    PRIVATES   ############################################################
  ##############################################################################

  defp widify_char(char) when (char >= 0x21 and char <= 0x2F), do: char + 0xFF00 - 0x0020
  defp widify_char(char) when (char >= 0x3A and char <= 0x40), do: char + 0xFF00 - 0x0020
  defp widify_char(char) when (char >= 0x5B and char <= 0x60), do: char + 0xFF00 - 0x0020
  defp widify_char(char) when (char >= 0x7B and char <= 0x7E), do: char + 0xFF00 - 0x0020
  defp widify_char(char) when (char >= 0x30 and char <= 0x39), do: char + 0xFF00 - 0x0020
  defp widify_char(char) when (char >= 0x61 and char <= 0x7A), do: char + 0xFF00 - 0x0020
  defp widify_char(char) when (char >= 0x41 and char <= 0x5A), do: char + 0xFF00 - 0x0020

  defp widify_char(char), do: char

  ##############################################################################

  defp unwidify_char(char) when (char >= 0xFF01 and char <= 0xFF0F), do: char + 0x0020 - 0xFF00
  defp unwidify_char(char) when (char >= 0xFF1A and char <= 0xFF20), do: char + 0x0020 - 0xFF00
  defp unwidify_char(char) when (char >= 0xFF3B and char <= 0xFF40), do: char + 0x0020 - 0xFF00
  defp unwidify_char(char) when (char >= 0xFF5B and char <= 0xFF5E), do: char + 0x0020 - 0xFF00
  defp unwidify_char(char) when (char >= 0xFF10 and char <= 0xFF19), do: char + 0x0020 - 0xFF00
  defp unwidify_char(char) when (char >= 0xFF41 and char <= 0xFF5A), do: char + 0x0020 - 0xFF00
  defp unwidify_char(char) when (char >= 0xFF21 and char <= 0xFF3A), do: char + 0x0020 - 0xFF00

  defp unwidify_char(char), do: char

  ##############################################################################
end
