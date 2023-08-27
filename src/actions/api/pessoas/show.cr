class Api::Pessoas::Show < ApiAction
  get "/pessoas/:pessoa_id" do
    plain_text "Render something in Api::Pessoas::Show"
  end
end
