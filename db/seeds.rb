# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

seed_images_path = Rails.root.join("db", "seeds", "images")

# Reset storefront catalog so seeds are deterministic.
# We clear line items first so Product deletes don't abort.
if defined?(LineItem)
  LineItem.delete_all
end

Product.find_each do |product|
  product.image.purge if product.image.attached?
  product.destroy!
end

seed_products = [
  {
    title: "Daughter of the Veil",
    description: %(
      <p>
        Step into a moody, moonlit world where ancient promises still matter and every choice carries a cost.
        <em>Daughter of the Veil</em> blends romantic tension with high-stakes fantasy, following a heroine caught
        between hidden bloodlines, dangerous magic, and a destiny that refuses to stay buried. Expect secret
        alliances, sharp betrayals, and moments of tenderness that hit harder because the stakes keep rising.
        If you like atmospheric settings, morally complex characters, and a plot that pushes forward with
        mystery, action, and heart, this story delivers a satisfying ride from the first page to the last.
      </p>
    ),
    price: 19.99,
    image_filename: "image1.jpg"
  },
  {
    title: "Westerly Cove: Luke",
    description: %(
      <p>
        A warm sunset, a quiet shoreline, and a small town that remembers everything—until it doesn’t.
        <em>Westerly Cove: Luke</em> is a paranormal romance that leans into cozy vibes while keeping a supernatural
        edge. The story centers on Luke, whose instincts and secrets collide with an outsider’s questions and
        the town’s unspoken rules. As strange signs stack up—omens, shifting loyalties, and a pull that feels
        bigger than simple attraction—two people must decide what they’re willing to risk for truth and love.
        It’s heartfelt, suspenseful, and perfect for readers who enjoy romance with mystery and magic.
      </p>
    ),
    price: 14.99,
    image_filename: "image2.jpg"
  },
  {
    title: "Occult America",
    description: %(
      <p>
        What happens when the hidden currents of history are placed under a bright light? <em>Occult America</em>
        explores the country’s lesser-known mystical traditions—from séance rooms and secret societies to
        strange experiments and cultural movements that shaped public imagination. This book connects the dots
        between belief, politics, and popular culture, showing how fascination with the unseen can influence
        real decisions in the world we share. It reads like an investigative tour through time, balancing
        curious anecdotes with broader context. Ideal for readers who enjoy American history with an eerie,
        thought-provoking twist and a trail of mysteries to follow.
      </p>
    ),
    price: 17.50,
    image_filename: "image3.jpg"
  },
  {
    title: "Need to Know: UFOs, the Military, and Intelligence",
    description: %(
      <p>
        Rumor becomes report, and report becomes policy. <em>Need to Know</em> investigates the long-running
        intersection of UFO accounts, military encounters, and intelligence programs, focusing on what was
        recorded, who took it seriously, and why secrecy became the default. Rather than leaning on simple
        explanations, the narrative highlights documents, patterns, and institutional incentives—how agencies
        communicate, what they classify, and what they refuse to confirm. It’s a grounded, tense read that
        keeps you turning pages, whether you’re skeptical, curious, or somewhere in between. Great for fans of
        investigative nonfiction and modern mysteries.
      </p>
    ),
    price: 16.00,
    image_filename: "image4.jpg"
  },
  {
    title: "Managing the Vampire’s Mansion",
    description: %(
      <p>
        Imagine inheriting a mansion with rules you can’t ignore and residents who definitely don’t sleep at
        night. <em>Managing the Vampire’s Mansion</em> is a playful, spooky story that mixes humor with
        supernatural chaos. Between mysterious rooms, curious artifacts, and guests who act suspiciously polite,
        the protagonist must learn how to keep the household from falling apart—while uncovering what the
        mansion really is and why it chose them. It’s charming, fast-paced, and full of imaginative details.
        Perfect for readers who want light fantasy with bite, cozy danger, and a clever found-family vibe.
      </p>
    ),
    price: 13.75,
    image_filename: "image5.jpg"
  }
]

seed_products.each do |attrs|
  product = Product.find_or_initialize_by(title: attrs[:title])
  product.description = attrs[:description]
  product.price = attrs[:price]

  image_path = seed_images_path.join(attrs[:image_filename])
  raise "Missing seed image: #{image_path}" unless File.exist?(image_path)

  desired_filename = attrs[:image_filename]
  current_filename = product.image.attached? ? product.image.filename.to_s : nil

  if current_filename != desired_filename
    product.image.purge if product.image.attached?
    content_type = Marcel::MimeType.for(Pathname.new(image_path), name: desired_filename)
    product.image.attach(
      io: File.open(image_path),
      filename: desired_filename,
      content_type:
    )
  end

  product.save!
end


# Pehle check karo ke User model exist karta hai ya nahi
if defined?(User)
  # Admin user find or create by email
  admin_email = "admin@example.com"
  admin_password = "password123"  # Change this to a secure password in production!
  
  admin_user = User.find_or_initialize_by(email: admin_email)
  
  if admin_user.new_record?
    admin_user.password = admin_password
    admin_user.password_confirmation = admin_password
    admin_user.save!
    puts "✅ Admin user created successfully!"
    puts "   Email: #{admin_email}"
    puts "   Password: #{admin_password}"
    puts "   ⚠️  Please change this password in production!"
  else
    puts "✅ Admin user already exists: #{admin_email}"
    # Agar user exist karta hai lekin password update karna ho to:
    # admin_user.update(password: admin_password, password_confirmation: admin_password)
  end
  
  # Agar admin field hai to set karo (agar aapke paas admin boolean field hai)
  if admin_user.respond_to?(:admin=)
    admin_user.admin = true unless admin_user.admin?
    admin_user.save! if admin_user.changed?
  end
  
  # Agar role field hai (jese enum ya string) to set karo
  if admin_user.respond_to?(:role=) && admin_user.role != "admin"
    admin_user.role = "admin"
    admin_user.save!
  end
  
else
  puts "⚠️  User model not found! Skipping admin user creation."
  puts "   Make sure you have generated the User model (e.g., with has_secure_password)"
end
