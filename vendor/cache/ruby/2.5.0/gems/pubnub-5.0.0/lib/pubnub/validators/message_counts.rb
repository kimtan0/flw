# Toplevel Pubnub module.
module Pubnub
  # Validator module that holds all validators modules
  module Validator
    # Validator for History event
    module MessageCounts
      include CommonValidator

      def validate!
        return if @skip_validate

        validate_channel!
      end

      private

      def validate_channel!
        chans = @channel
        chans = @channel.split(',') if @channel.is_a? String
        tokens = @timetokens

        if tokens.length.zero?
          raise(
            ArgumentError.new(
              object: self,
              message: 'channel_timetokens: must contain single or multiple timetokens equaling to number of channels given must be provided.'
            ),
            'channel_timetokens: must contain single or multiple timetokens equaling to number of channels given must be provided.'
          )
        elsif tokens.length > 1 && tokens.length != chans.length
          raise(
            ArgumentError.new(
              object: self,
              message: 'Number of channel_timetokens: elements must be 1 or same as number of provided channels.'
            ),
            'Number of channel_timetokens: elements must be 1 or same as number of provided channels.'
          )
        end
      end
    end
  end
end
