Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      column :username, String, size: 255, null: false, index: { unique: true }
      column :encrypted_password, String, size: 255, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end

    create_table :clients do
      primary_key :id

      column :name, String, size: 255, null: false
      column :redirect_uri, String, size: 255, null: false
      column :key, String, size: 255, null: false, index: { unique: true }
      column :secret, String, size: 255, null: false, index: { unique: true }

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end

    create_table :access_tokens do
      primary_key :id
      column :resource_owner_id, Integer, null: false, index: true
      column :client_id, Integer, null: false, index: true

      column :token, String, size: 255, null: false, index: { unique: true }
      column :refresh_token, String, size: 255, index: { unique: true }
      column :scopes, String, size: 255

      column :revoked_at, DateTime
      column :expires_at, DateTime, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end

    create_table :access_grants do
      primary_key :id
      column :resource_owner_id, Integer, null: false, index: true
      column :client_id, Integer, null: false, index: true

      column :token, String, size: 255, null: false, index: { unique: true }
      column :redirect_uri, String, size: 255, null: false
      column :scopes, String, size: 255

      column :revoked_at, DateTime
      column :expires_at, DateTime, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
