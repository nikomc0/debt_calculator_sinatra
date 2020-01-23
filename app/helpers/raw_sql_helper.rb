module RawSqlHelper
  def sql_quote(string)
    @conn ||= ::ActiveRecord::Base.connection
    @conn.quote(string)
  end

  def sql_column_quote(string)
    @conn ||= ::ActiveRecord::Base.connection
    @conn.quote_column_name(string)
  end

  def sqlize_array(array)
    joined_string = array.map do |member|
      sql_quote(member)
    end.join(',')
    "(#{joined_string})"
  end

  def get_conn
    @conn = ::ActiveRecord::Base.connection
  end
end