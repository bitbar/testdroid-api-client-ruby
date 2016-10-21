module TestdroidAPI
  class FilterBuilder

    def initialize
      @filters = []
    end

    private
    def check_type(subject)
      if !!subject == subject # check if it's boolean
        return 'b'
      elsif (/^[0-9]{13}$/ =~ subject) != nil  # check if it's timestamp
        return 'd'
      elsif (/^[0-9]+(?:\.[0-9]+)?$/ =~ subject) != nil  # check if it's number
        return 'n'
      else
        return 's'
      end
    end

    def add(name, value, operand, type, check_nil=false)
      unless value.is_a? Array
        value = [value]
      end

      if value.length == 0
        return self
      end

      # auto-convert
      value.each_with_index do |val, index|
        if val.is_a? Time
          value[index] = val.to_i.to_s
        elsif val.is_a? Fixnum
          value[index] = val.to_s
        end
      end

      # auto-check type
      if type.nil?
        value.each do |val|
          next if val.nil?
          type = check_type(val)
          break
        end

        if operand == 'in'
          type = 'l'+type
        end
      end

      # check nil existance
      if check_nil
        is_nil = false
        value.each do |val|
          next unless val.nil?
          is_nil = true
        end

        if is_nil
          value = value.select { |item| !item.nil? }
          operand += 'ornull'
        end
      end

      # add filter
      @filters.push(FilterItem.new(name, value, operand, type))
    end

    public
    def gt(name, value)
      add(name, value, 'gt', 'n')
    end

    def lt(name, value)
      add(name, value, 'lt', 'n')
    end

    def after(name, value)
      add(name, value, 'after', 'd', true)
    end

    def before(name, value)
      add(name, value, 'before', 'd', true)
    end

    def on(name, value)
      add(name, value, 'on', 'd')
    end

    def eq(name, value)
      add(name, value, 'eq', nil)
    end

    def contains(name, value)
      add(name, value, 'contains', 's')
    end

    def like(name, value)
      nil # TODO (waiting for BE support)
    end

    def empty(name, value)
      nil # TODO (waiting for BE support)
    end

    def isnull(name, operand)
      add(name, nil, 'isnull', operand)
    end

    def in(name, value)
      add(name, value, 'in', nil, true)
    end


    def to_s
      parts = []
      @filters.each do |filter|
        val = ''
        if filter.value.length > 1 or not filter.value.nil?
          val = '_' + filter.values
        end
        parts.push( filter.to_s + val )
      end
      parts.join(';')
    end

  end

  class FilterItem
    attr_accessor :name, :value, :operand, :type

    def initialize(name, value, operand, type)
      @name, @value, @operand, @type = name, value, operand, type
    end

    def values
      @value.join('|')
    end

    def to_s
      "#{@type}_#{@name}_#{@operand}"
    end
  end
end
