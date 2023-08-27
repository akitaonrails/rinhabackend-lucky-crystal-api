class BadRequestError < Exception
  include Lucky::RenderableError

  def renderable_status : Int32
    400
  end

  def renderable_message : String
    "Bad Request"
  end
end
