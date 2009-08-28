# Class ThreadStore
class ThreadStore
	attr_reader :cycles, :max

	# Create a new ThreadStore.
	#
	# max:: max number of threads to store (when exhausted, older threads will
	# just be killed and discarded).
	def initialize(max = 100)
		@store  = []
		@max    = max
		@cycles = 0
		@killer_thread = Thread.new do
			loop do
				sleep 2 while @store.empty?
				sleep 1
				@store.each_with_index do |thread, i|
					th = @store.delete_at(i) if thread.nil? or ! thread.alive?
					th = nil
				end
				@cycles += 1
			end
		end
	end

	# :nodoc:
	def inspect
		sprintf("#<%s:0x%x @max=%d, @size=%d @cycles=%d>", self.class.name, __id__, @max, size, @cycles)
	end

	# Add a new thread to the ThreadStore
	def add(thread)
		if thread.instance_of?(Thread) and thread.respond_to?(:alive?)
			@store << thread
			@store.shift.kill while @store.length > @max
		end
  end

	# Kill all threads
	def kill!
		@store.shift.kill while @store.length > 0
	end

	# How long is our ThreadStore
	def size; @store.length; end

end # of class ThreadStore
