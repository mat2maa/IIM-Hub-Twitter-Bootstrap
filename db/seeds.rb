SupplierCategory.create!(name: 'Video Distributors', remarks: '-')
SupplierCategory.create!(name: 'Movie Distributors', remarks: '-')
SupplierCategory.create!(name: 'Laboratories',       remarks: '-')
SupplierCategory.create!(name: 'Production Studios', remarks: '-')

Role.create!([
                {name: "administrator"},
                {name: "programmer"},
                {name: "video_programmer"},
                {name: "client"}
             ])