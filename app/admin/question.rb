ActiveAdmin.register Question do
  permit_params :text, :slug, :source, :source_url, :is_featured, :topic,
    answers_attributes: [:id, :label, :is_correct, :feedback_id, :_destroy]

  controller do
    defaults finder: :find_by_slug

    def update
      params[:question].merge!({ slug: nil })
      update!
    end
  end

  form do |f|
    f.inputs do
      f.input :text
      f.input :source
      f.input :source_url
      f.input :topic
      f.input :is_featured
    end

    f.inputs do
      f.has_many :answers, heading: "Answers", allow_destroy: true, new_record: true do |af|
        af.input :label
        af.input :is_correct
        af.input :feedback
      end
    end

    f.actions
  end
end
