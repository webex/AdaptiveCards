// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
#if USE_WINUI3
using Microsoft.UI.Xaml.Controls;
#else
using Windows.UI.Xaml.Controls;
#endif

#if !USE_WINUI3
using Windows.UI.Xaml.Controls;
#endif
using AdaptiveCardVisualizer.ViewModel;

// The User Control item template is documented at https://go.microsoft.com/fwlink/?LinkId=234236

namespace AdaptiveCardVisualizer
{
    public sealed partial class GenericDocumentView : UserControl
    {
        public GenericDocumentView()
        {
            this.InitializeComponent();
        }
    }
}
