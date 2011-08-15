module ApplicationHelper
   def title
      base_title = "Pupetto App"
      if @title.nil?
         base_title
      else 
         "#{base_title} | #{@title}"
      end
   end
 
   def logo
      image_tag("logoars.jpg", :alt => "Pupetto App", :class => "round")
   end
end
