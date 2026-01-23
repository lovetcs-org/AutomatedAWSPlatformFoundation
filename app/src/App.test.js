import { render } from '@testing-library/react';
import App from './App';

// Mock the entire 3D component 
jest.mock('./lovetcs-app', () => {
  return function MockLovetcsApp() {
    return <div data-testid="mock-3d">3D Component</div>;
  };
});

describe('App Component', () => {
  test('renders without crashing', () => {
    const { container } = render(<App />);
    expect(container).toBeInTheDocument();
  });

  // Check App has correct CSS class
  test('has App class on root element', () => {
    const { container } = render(<App />);
    const appDiv = container.querySelector('.App');
    expect(appDiv).toBeInTheDocument();
  });

  // Check 3D component is rendered
  test('renders the 3D component', () => {
    const { getByTestId } = render(<App />);
    const mockComponent = getByTestId('mock-3d');
    expect(mockComponent).toBeInTheDocument();
    expect(mockComponent).toHaveTextContent('3D Component');
  });
});