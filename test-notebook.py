            __import__(package.replace('-', '_'))
            print(f"✅ {package}")
        except ImportError:
            print(f"❌ {package} - not installed")
    
    print("\n" + "=" * 50)
    print("🎯 Environment test complete!")
    print("\n💡 Next steps:")
    print("1. Open Video2X_Codespace_Adapted.ipynb in VS Code")
    print("2. Run cells sequentially")
    print("3. Upload test video to input/ directory")
    print("4. Configure and process")

if __name__ == "__main__":
    test_environment()
