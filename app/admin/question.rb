ActiveAdmin.register Question do
  permit_params :text, :source, :source_url, :is_featured, :topic

  controller do
    def find_resource
      scoped_collection.where(slug: params[:id]).first!
    end

    # def update
    #   @question = Question.friendly.find(params[:id])
    #   @question.slug = nil
    #   @question.update(permitted_params)
    # end
  end

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

end
