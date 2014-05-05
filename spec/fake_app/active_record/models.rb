# models
class User < ActiveRecord::Base
  has_many :authorships
  has_many :readerships
  has_many :books_authored, :through => :authorships, :source => :book
  has_many :books_read, :through => :readerships, :source => :book
  has_many :addresses, :class_name => 'User::Address'

  #attr_accessible :name, :age, :dob

  def readers
    User.joins(:books_read => :authors).where(:authors_books => {:id => self})
  end

  scope :by_name, order(:name)
  scope :by_read_count, lambda {
    cols = if connection.adapter_name == "PostgreSQL"
             column_names.map { |column| %{"users"."#{column}"} }.join(", ")
           else
             '"users"."id"'
           end
    group(cols).select("count(readerships.id) AS read_count, #{cols}").order('read_count DESC')
  }
end
class Authorship < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
end
class Readership < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  #attr_accessible :user_id, :book_id
end
class Book < ActiveRecord::Base
  has_many :authorships
  has_many :readerships
  has_many :authors, :through => :authorships, :source => :user
  has_many :readers, :through => :readerships, :source => :user
end
# a model that is a descendant of AR::Base but doesn't directly inherit AR::Base
class Admin < User
end
# a model with namespace
class User::Address < ActiveRecord::Base
  belongs_to :user
end

#migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:gem_defined_models) { |t| t.string :name; t.integer :age }
    create_table(:users) { |t| t.string :name; t.integer :age; t.datetime :dob; t.timestamps }
    create_table(:books) { |t| t.string :title }
    create_table(:readerships) { |t| t.integer :user_id; t.integer :book_id }
    create_table(:authorships) { |t| t.integer :user_id; t.integer :book_id }
    create_table(:user_addresses) { |t| t.string :street; t.integer :user_id }

    create_table :reservation_commission_receivables do |t|
      t.string :type
      t.datetime :start_date
      t.datetime :end_date
      t.references :check_in
      t.references :hotel
      t.references :invoice
      t.float :room_charge
      t.float :amount

      t.timestamps
    end

    create_table :reservation_commission_invoices do |t|
      t.string :type
      t.string :title
      t.float :total_room_charge
      t.float :total_amount
      t.string :status
      t.datetime :invoiced_at
      t.references :hotel

      t.timestamps
    end
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up