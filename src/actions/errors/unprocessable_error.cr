class UnprocessableError < Exception
  include Lucky::RenderableError

  def initialize(@message : String = "Unprocessable Entity")
  end

  def renderable_status : Int32
    422
  end

  def renderable_message : String
    @message || "Unprocessable Entity"
  end
end
