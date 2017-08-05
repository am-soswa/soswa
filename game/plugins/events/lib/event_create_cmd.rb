module AresMUSH

  module Events
    class EventCreateCmd
      include CommandHandler
      
      attr_accessor :title, :date_time_desc

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.title = titlecase_arg(args.arg1)
        self.date_time_desc = trim_arg(args.arg2)
      end
      
      def required_args
        {
          args: [ self.title, self.date_time_desc ],
          help: 'events'
        }
      end
      
      def handle
        datetime, desc, error = Events.parse_date_time_desc(self.date_time_desc)
        
        if (error)
          client.emit_failure error
          return
        end
        
        event = Event.create(title: self.title, 
          starts: datetime, 
          description: desc,
          character: enactor)
          
          Global.client_monitor.emit_all_ooc t('events.event_created', :title => event.title,
             :starts => event.start_datetime_standard, :name => enactor_name)
      end
    end
  end
end