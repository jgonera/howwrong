ActiveAdmin.register Question do
  permit_params :text, :slug, :source, :source_url, :is_featured, :topic

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

    f.actions
  end
end
