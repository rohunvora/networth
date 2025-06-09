#!/usr/bin/env python3
"""
Quick app icon generator for Net Worth Tracker
Creates a simple 1024x1024 icon with "NW" text
"""

try:
    from PIL import Image, ImageDraw, ImageFont
    import os
    
    # Create 1024x1024 image with gradient background
    size = (1024, 1024)
    img = Image.new('RGB', size, color='#007AFF')
    
    # Create drawing context
    draw = ImageDraw.Draw(img)
    
    # Draw rounded rectangle background
    margin = 100
    draw.rounded_rectangle(
        [margin, margin, size[0]-margin, size[1]-margin],
        radius=100,
        fill='#FFFFFF'
    )
    
    # Add "NW" text
    text = "NW"
    try:
        # Try to use system font
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 400)
    except:
        # Fallback to default font
        font = ImageFont.load_default()
    
    # Get text size
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    # Center text
    x = (size[0] - text_width) // 2
    y = (size[1] - text_height) // 2 - 50  # Slight offset up
    
    # Draw text
    draw.text((x, y), text, fill='#007AFF', font=font)
    
    # Add subtitle
    subtitle = "Net Worth"
    try:
        subtitle_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 100)
    except:
        subtitle_font = ImageFont.load_default()
    
    bbox = draw.textbbox((0, 0), subtitle, font=subtitle_font)
    subtitle_width = bbox[2] - bbox[0]
    subtitle_x = (size[0] - subtitle_width) // 2
    subtitle_y = y + text_height + 50
    
    draw.text((subtitle_x, subtitle_y), subtitle, fill='#666666', font=subtitle_font)
    
    # Save icon
    output_path = "NetworthTracker/NetworthTracker/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path, "PNG")
    
    print(f"✅ Icon created at: {output_path}")
    print("📱 Drag this into Xcode's AppIcon asset!")
    
except ImportError:
    print("❌ Pillow not installed. To create icon:")
    print("1. pip install Pillow")
    print("2. python generate_temp_icon.py")
    print("\nOr create manually:")
    print("1. Go to https://www.canva.com")
    print("2. Create 1024x1024 design")
    print("3. Add 'NW' text")
    print("4. Export as PNG") 