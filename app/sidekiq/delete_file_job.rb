# frozen_string_literal: true

class DeleteFileJob
  include Sidekiq::Job

  def perform(file_path)
    Pathname.new(file_path).delete if Pathname.new(file_path).exist?
  end
end
