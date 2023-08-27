require "../spec_helper"

describe SavePessoa do
  describe "validations" do
    it "is invalid if apelido is too long" do
      operation = SavePessoa.new(apelido: "abcdefghijklmnopqrstuvwxyz0123456789")
      operation.valid?.should eq false
    end
  end
end
