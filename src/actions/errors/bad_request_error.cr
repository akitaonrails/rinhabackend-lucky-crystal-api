class BadRequestError < Exception
  include Lucky::RenderableError

  def initialize(@message : String = "Bad Request")
  end

  def renderable_status : Int32
    400
  end

  def renderable_message : String
    @message || "Bad Request"
  end
end
