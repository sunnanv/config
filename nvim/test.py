def toggle_test(lines):
   print("Can you see the indent lines?")
   for line in lines:
     if line == "visible":
       print("Hooray!")
       print("I can see them.")
     else:
       print("Uh-oh...")
       print("Something's wrong!")

toggle_test(['a'])

