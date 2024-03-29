defmodule PolarWeb.ErrorHTMLTest do
  use PolarWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(PolarWeb.ErrorHTML, "404", "html", []) =~ "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(PolarWeb.ErrorHTML, "500", "html", []) =~ "Something went wrong."
  end
end
