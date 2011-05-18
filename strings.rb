name = 'foo'

mail = <<END
Dear #{name},
Unfortunately we cannot process your insurance claim at this
time. This is because we are a bakery, not an insurance company.
Signed,
Nil, Null, and None
Bakers to Her Majesty the Singleton
END

# C printf style strings
template = 'Oceania has always been at war with %s.'
template % 'Eurasia'
template % 'Eastasia'

'To 2 decimal places: %.2f' % Math::PI
'Zero-padded: %.5d' % Math::PI

# ERB style interpolation
require 'erb'
template = ERB.new %q{Chunky <%= food %>!}
food = "bacon"
template.result(binding) # can omit binding argument when not in irb

class String
  def word_count
    downcase.scan(/\w+/).inject(Hash.new(0)) do |frequency, word| 
      frequency[word] += 1
      frequency
    end
  end
end

# Useful for producing tabular alighned messages
" output message:".ljust(20) # rjust, center

# fmt like
class String
  # Could lead to orphan lines
  def wrap_regex(width=78)
    gsub /(.{1,#{width}})(\s+|\Z)/, "\\1\n"
  end
  
  def wrap_array(width=78)
    lines, line, words = [], "", split(/\s+/)
    
    until words.empty?
      word = words.shift + ' '
      
      if line.size + word.size > width
        lines << line + "\n"
        line = ""
      end
        
      line << word
    end
    
    lines.to_s
  end
end

poem = %q{It is an ancient Mariner,
And he stoppeth one of three.
"By thy long beard and glittering eye,
Now wherefore stopp'st thou me?}

