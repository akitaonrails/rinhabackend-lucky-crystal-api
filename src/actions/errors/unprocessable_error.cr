class UnprocessableError < Exception
  include Lucky::RenderableError

  def renderable_status : Int32
    422
  end

  def renderable_message : String
    "Unprocessable Entity"
  end
end
