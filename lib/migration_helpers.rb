module MigrationHelpers

	def foreign_key(from_table, from_column, to_table)
		constraint_name = "fk_#{from_table}_#{to_table}"
		
		execute %{
			CREATE TRIGGER #{constraint_name}_insert
			BEFORE INSERT ON #{from_table}
			FOR EACH ROW BEGIN
				SELECT
					RAISE(ABORT, "constraint violation: #{constraint_name}")
				WHERE
					(SELECT id FROM #{to_table} WHERE id = NEW.#{from_column}) IS NULL;
			END;
		}
		
		execute %{
			CREATE TRIGGER #{constraint_name}_update
			BEFORE UPDATE ON #{from_table}
			FOR EACH ROW BEGIN
				SELECT
					RAISE(ABORT, "constraint violation: #{constraint_name}")
				WHERE
					(SELECT id FROM #{to_table} WHERE id = NEW.#{from_column}) IS NULL;
			END;
		}
		
		execute %{
			CREATE TRIGGER #{constraint_name}_delete
			BEFORE DELETE ON #{to_table}
			FOR EACH ROW BEGIN
				SELECT
					RAISE(ABORT, "constraint violation: #{constraint_name}")
				WHERE
					(SELECT id FROM #{from_table} WHERE #{from_column} = OLD.id) IS NOT NULL;
		END;
		}
	end

#another version of the migration helper
=begin
	def foreign_key(from_table, from_column, to_table, to_column, suffix=nil, on_delete='SET NULL', on_update='CASCADE')
		constraint_name = "fk_#{from_table}_#{to_table}"
		constraint_name += "_#{suffix}" unless suffix.nil?
		execute %{alter table #{from_table}
			add constraint #{constraint_name}
		  foreign key (#{from_column})
		  references #{to_table}(#{to_column})
		  on delete #{on_delete}
		  on update #{on_update}
   	}
 	end

 	def drop_foreign_key(from_table, to_table, suffix=nil)
		constraint_name = "fk_#{from_table}_#{to_table}"
	  constraint_name += "_#{suffix}" unless suffix.nil?
	  execute "alter table #{from_table} drop foreign key #{constraint_name}"
	  execute "alter table #{from_table} drop key #{constraint_name}"
 	end
=end
end
