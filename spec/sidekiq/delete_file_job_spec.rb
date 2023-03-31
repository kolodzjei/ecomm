# frozen_string_literal: true

require "rails_helper"
RSpec.describe(DeleteFileJob, type: :job) do
  describe "#perform" do
    let(:file_path) { Rails.root.join("tmp", "test.txt").to_s }

    context "when file exists" do
      before { File.open(file_path, "w") { |f| f.write("test") } }

      it "deletes file" do
        expect(Pathname.new(file_path)).to(exist)
        DeleteFileJob.new.perform(file_path)
        expect(Pathname.new(file_path)).not_to(exist)
      end
    end

    context "when file does not exist" do
      it "does not raise error" do
        expect { DeleteFileJob.new.perform(file_path) }.not_to(raise_error)
      end
    end
  end
end
