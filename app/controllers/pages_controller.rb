class PagesController < ApplicationController
  def index
    @projects = Project.all.includes(documents: {
                                       packages: {
                                         products: {
                                           product_classes: :dynamic_values
                                         }
                                       }
                                     })
  end
end
