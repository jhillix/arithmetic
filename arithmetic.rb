=begin
    A simple arithmetic game similiar to BSD's "arithmetic"
=end

# Catch signal interrupt (Ctrl-c).
begin

    # Randomly selects the math operator.
    def operator
        operator = rand(42..47)
        case operator
        when 42 then "*"
        when 43 then "+"
        when 45 then "-"
        when 47 then "/"
        else "+" 
        end
    end

    # Check the user's answer.
    def check(op1, op, op2)
        case op
        when "*" then op1 * op2
        when "+" then op1 + op2
        when "-" then op1 - op2
        when "/" then op1.fdiv(op2)
        end
    end

    # Helps determine the pace for the user.
    def pace(score)
        total = score["correct".to_sym] + score["incorrect".to_sym]
        percent = (score["correct".to_sym].fdiv(total)) * 100
    end

    # Keep a tally on the users score.
    score = {
        correct: 0,
        incorrect: 0
    }

    i = 1
    # Start off easy.
    range_threshhold = 10
    # Loop forever or until the interrupt signal is received.
    loop {
        # Increment the duration.
        i += 1

        # Randomly choose the operands and operator.
        op1 = rand(0..range_threshhold)
        op2 = rand(0..range_threshhold)
        op = operator

        # Prompt the user.
        print "#{op1} #{op} #{op2} = "
        answer = gets.chomp

        if check(op1, op, op2) == answer.to_i
            # Inform the user of correct choice and add a point to the score.
            puts "Right!"
            score["correct".to_sym] = score["correct".to_sym].next

            # For every tenth iteration, if we have a high score then Kick it up a notch!
            if i % 10 == 0 and pace(score) >= 60
                puts "Are you asking for a challenge!!! --S.B."
                range_threshhold += 10
                # Reset the duration.
                i = 1
            end
        else
            # Inform the user of the incorrect choice and add a point to the incorrect tally.
            puts "Try again"
            score["incorrect".to_sym] = score["incorrect".to_sym].next

            # Help! Help! I'm being oppressed!
            # For every tenth iteration, if we have a low score then step the pace down.
            if i % 10 == 0 and range_threshhold > 10 and pace(score) <= 30
                puts "Pumping the brakes. It looks like this pace is too much for you."
                range_threshhold -= 10
                # Reset the duration.
                i = 1
            end
        end
    }

rescue Interrupt => e
    # Show the score and exit.
    puts "\n\n"
    score.each do |key, value|
        print "#{key}: #{value} "
    end
    puts "\nExiting"
end