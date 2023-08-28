class NotFoundError < Exception
  include Lucky::RenderableError

  def renderable_status : Int32
    404
  end

  def renderable_message : String
    "Not Found"
  end
end
