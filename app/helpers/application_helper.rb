module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "Cacklist"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    image_tag("bushcover.png", :alt => "Cacklist", :class => "round")
  end  



end
