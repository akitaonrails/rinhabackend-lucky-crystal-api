class NotFoundError < Exception
  include Lucky::RenderableError

  def initialize(@message : String = "Not Found")
  end

  def renderable_status : Int32
    404
  end

  def renderable_message : String
    @message || "Not Found"
  end
end
