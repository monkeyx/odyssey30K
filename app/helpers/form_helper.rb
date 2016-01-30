module FormHelper
  def title_editable(name, path)
    editable(title(name),'name',path, "document.title = content.current + '- Odyssey 30K';")
  end
  
  def editable(display_text, field_name, post_url, execute_afterwards = "", field_id = "#{field_name}-editable")
    content_for :editable_jquery do
      "$('\##{field_id}').editable({onEdit:begin_#{field_name},submit:'save',cancel:'cancel',onSubmit:end_#{field_name}});
      function begin_#{field_name}(){
      }
  
      function end_#{field_name}(content){
        $.post('#{post_url}', {#{field_name}: content.current});
        #{execute_afterwards}
      }
      "
    end
    "<span id='#{field_id}' class='editable' title='Click to edit'>#{display_text}</span>"
  end
end