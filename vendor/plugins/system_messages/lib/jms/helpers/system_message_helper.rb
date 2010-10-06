module JMS 
  module Helpers
    module SystemMessageHelper
      def system_msg(message, options={})
        base_options = {:class => "system-message #{message.level}", :id => "system_message_#{message.id}"}.merge(options)
        
        if message.dismissable?
          header = header_div(message.message + " " + link_to_remote("<i>(close)</i>", :url => {:controller => 'system_messages', :action => 'dismiss', :id => message.id}), message.level)
        else
          header = header_div(message.message, message.level)
        end

        final_result = content_tag(:div, header, base_options)
        final_result = final_result.gsub('&quot;', '"')
        final_result = final_result.gsub('&lt;', '<')
        final_result = final_result.gsub('&gt;', '>')
      end
  
      def system_messages_for(obj, options={})
        messages = obj.system_messages.select(&:viewable?).
        map {|msg| system_msg(msg, options)}
       
        messages.join("\n")
      end
  
      def system_messages(options={})
        SystemMessage.global.viewable.map {|msg| system_msg(msg, options)}.join("\n")
      end
  
      def static_system_message(level, options={}, &block)
        body   = capture(&block)
        header = header_div(body, level)
        
        concat(content_tag(:div, body,
              {:class => "system-message #{level}"}.merge(options)), 
              block.binding)
      end
      
      private
      
      def header_div(text, level)
        content_tag(:div, content_tag(:span, text, :class => level), :class => "system-message-header #{level}")
      end
      
    end
  end
end
