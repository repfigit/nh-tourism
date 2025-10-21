# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# IMPORTANT: Do NOT add Administrator data here!
# Administrator accounts should be created manually by user.
# This seeds file is only for application data (products, categories, etc.)

# Write your seed data here

# Clear existing data
Destination.destroy_all
Attraction.destroy_all
Activity.destroy_all

# Create Destinations
Destination.create!([
  {
    name: 'White Mountains',
    location: 'Northern NH',
    description: 'Majestic peaks, scenic trails, and stunning vistas await in New Hampshire\'s crown jewel. The White Mountains offer year-round recreation including hiking, skiing, and breathtaking scenic drives.',
    featured: true,
    image_url: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'
  },
  {
    name: 'Lake Winnipesaukee',
    location: 'Lakes Region',
    description: 'Crystal-clear waters perfect for boating, fishing, and relaxing summer getaways. New Hampshire\'s largest lake offers 283 miles of shoreline and endless water activities.',
    featured: true,
    image_url: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800'
  },
  {
    name: 'Portsmouth',
    location: 'Seacoast',
    description: 'Historic seaport town with colonial architecture, fine dining, and coastal charm. Explore centuries of history in this vibrant waterfront community.',
    featured: true,
    image_url: 'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800'
  },
  {
    name: 'Franconia Notch',
    location: 'White Mountains',
    description: 'Spectacular mountain pass featuring waterfalls, hiking trails, and natural wonders including the famous Flume Gorge.',
    featured: false,
    image_url: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800'
  },
  {
    name: 'Squam Lake',
    location: 'Lakes Region',
    description: 'Serene lake setting famous for its natural beauty and wildlife viewing opportunities. Known as the filming location for On Golden Pond.',
    featured: false,
    image_url: 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=800'
  }
])

# Create Attractions
Attraction.create!([
  {
    name: 'Mount Washington',
    location: 'White Mountains',
    description: 'The highest peak in the Northeast at 6,288 feet, offering incredible views and challenging hiking.',
    category: 'Outdoor',
    image_url: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800'
  },
  {
    name: 'Cannon Mountain',
    location: 'Franconia Notch',
    description: 'Year-round adventure with world-class skiing in winter and aerial tramway in summer.',
    category: 'Outdoor',
    image_url: 'https://images.unsplash.com/photo-1605540436563-5bca919ae766?w=800'
  },
  {
    name: 'Strawbery Banke Museum',
    location: 'Portsmouth',
    description: 'An outdoor history museum showcasing 300 years of life in a Portsmouth neighborhood.',
    category: 'Historic',
    image_url: 'https://images.unsplash.com/photo-1518005020951-eccb494ad742?w=800'
  },
  {
    name: 'Flume Gorge',
    location: 'Franconia Notch',
    description: 'A natural gorge extending 800 feet at the base of Mount Liberty with stunning waterfalls.',
    category: 'Nature',
    image_url: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800'
  }
])

# Create Activities  
Activity.create!([
  {
    name: 'Hiking the Presidential Range',
    description: 'Challenge yourself with trails leading to peaks named after U.S. presidents. Experience alpine terrain and spectacular views.',
    duration: 'Full Day',
    difficulty: 'Hard'
  },
  {
    name: 'Lake Cruise',
    description: 'Relax on a scenic boat tour of Lake Winnipesaukee, learning about the region\'s history and wildlife.',
    duration: '2-3 hours',
    difficulty: 'Easy'
  },
  {
    name: 'Fall Foliage Drive',
    description: 'Experience New England\'s famous autumn colors along the Kancamagus Highway, one of America\'s most scenic byways.',
    duration: '3-4 hours',
    difficulty: 'Easy'
  },
  {
    name: 'White Water Rafting',
    description: 'Navigate exciting rapids on the Pemigewasset River for an adrenaline-pumping adventure.',
    duration: 'Half Day',
    difficulty: 'Moderate'
  },
  {
    name: 'Skiing & Snowboarding',
    description: 'Hit the slopes at world-class ski resorts offering runs for all skill levels.',
    duration: 'Full Day',
    difficulty: 'Moderate'
  },
  {
    name: 'Historic Walking Tour',
    description: 'Explore Portsmouth\'s colonial past with a guided walking tour through historic downtown.',
    duration: '1-2 hours',
    difficulty: 'Easy'
  }
])

puts "Created #{Destination.count} destinations"
puts "Created #{Attraction.count} attractions"
puts "Created #{Activity.count} activities"
